import firebase_admin
from firebase_admin import credentials, storage
from firebase_admin import firestore
import dht11
import RPi.GPIO as GPIO
from time import sleep
from gpiozero import DistanceSensor
import busio
import digitalio
import board
import adafruit_mcp3xxx.mcp3008 as MCP
from adafruit_mcp3xxx.analog_in import AnalogIn
import geocoder
from picamera import PiCamera
import datetime
from twilio.rest import Client



############# Setup Starts #############

# GPIO Mode (BOARD / BCM)
GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)

# Set GPIO Pins
PWMA = 4 #7
AIN1 = 18 #12
AIN2 = 17 #11
PWMB = 24 #18
BIN1 = 22 #15
BIN2 = 23 #16
LED_PIN = 27
GPIO.setup(PWMA, GPIO.OUT)
GPIO.setup(AIN1, GPIO.OUT)
GPIO.setup(AIN2, GPIO.OUT)
GPIO.setup(PWMB, GPIO.OUT)
GPIO.setup(BIN1, GPIO.OUT)
GPIO.setup(BIN2, GPIO.OUT)
GPIO.setup(LED_PIN, GPIO.OUT)

# Setup the DHT11 Sensor
DHT11PIN = 21
instance = dht11.DHT11(pin=DHT11PIN) # temperature & humidity

# Setup the Distance Sensor
sensor = DistanceSensor(26,20) # Distance sensor

# Setup the MQ5 Sensor
spi = busio.SPI(clock=board.SCK, MISO=board.MISO, MOSI=board.MOSI) # create the spi bus
cs = digitalio.DigitalInOut(board.D5) # create the cs (chip select)
mcp = MCP.MCP3008(spi, cs) # create the mcp object
chan = AnalogIn(mcp, MCP.P0) # create an analog input channel on pin 0


# Connect to the Firebase
bucket_name = "gas-leakage-f87ff.appspot.com"
cred = credentials.Certificate('serviceAccountKey.json')
firebase_admin.initialize_app(cred, {'storageBucket': bucket_name})

# Create a Cloud Firestore client
database = firestore.client()
new_collection = database.collection("users")
document = new_collection.document('pi')

# Twilio Setup
account_sid = 'AC78fec64218509a793241d1a18d6b1a98'
auth_token = 'dae1d019406675166fdc7d11a672a333'
client = Client(account_sid, auth_token)

iterations = 0

############# Setup Complete #############

# Turn off all the motors
def turnOffMotors():
    GPIO.output(AIN1, GPIO.LOW)
    GPIO.output(AIN2, GPIO.LOW)
    GPIO.output(PWMA, GPIO.LOW)
    GPIO.output(BIN2, GPIO.LOW) 
    GPIO.output(BIN1, GPIO.LOW) 
    GPIO.output(PWMB, GPIO.LOW)
    print("Motors are off")
    return

# Forward motion
def forward():
    GPIO.output(AIN1, GPIO.LOW)
    GPIO.output(AIN2, GPIO.HIGH)
    GPIO.output(PWMA, GPIO.HIGH)
    GPIO.output(BIN2, GPIO.LOW)
    GPIO.output(BIN1, GPIO.HIGH)
    GPIO.output(PWMB, GPIO.HIGH)
    print("Moving forward")
    return

# Left motion
def left():
    GPIO.output(AIN1, GPIO.LOW)
    GPIO.output(AIN2, GPIO.HIGH)
    GPIO.output(PWMA, GPIO.HIGH)
    GPIO.output(BIN2, GPIO.HIGH)
    GPIO.output(BIN1, GPIO.LOW)
    GPIO.output(PWMB, GPIO.HIGH)
    print("Moving left")
    return

# Right motion
def right():
    GPIO.output(AIN1, GPIO.HIGH)
    GPIO.output(AIN2, GPIO.LOW)
    GPIO.output(PWMA, GPIO.HIGH)
    GPIO.output(BIN2, GPIO.LOW)
    GPIO.output(BIN1, GPIO.HIGH)
    GPIO.output(PWMB, GPIO.HIGH)
    print("Moving right")
    return

# Backward motion
def backward():
    GPIO.output(AIN1, GPIO.HIGH)
    GPIO.output(AIN2, GPIO.LOW)
    GPIO.output(PWMA, GPIO.HIGH)
    GPIO.output(BIN2, GPIO.HIGH)
    GPIO.output(BIN1, GPIO.LOW)
    GPIO.output(PWMB, GPIO.HIGH)
    print("Moving backward")
    return

# Stop motion
def stop():
    GPIO.output(AIN1, GPIO.LOW)
    GPIO.output(AIN2, GPIO.LOW)
    GPIO.output(PWMA, GPIO.LOW)
    GPIO.output(BIN2, GPIO.LOW)
    GPIO.output(BIN1, GPIO.LOW)
    GPIO.output(PWMB, GPIO.LOW)
    print("Stop")
    return


# Read the temperature and humidity
def readHumidityTemperature():
    result = instance.read()
    if result.is_valid():
        print("Temp: %d C" % result.temperature +' '+"Humid: %d %%" % result.humidity)
        # setHumidityTemperature(result)
        return result
    
# Read the distance
def readDistance():
    distance = sensor.distance
    print("Distance: %.1f cm" % (distance * 100))
    if distance < 0.06:
        stop()
    return distance


# Read the Gas Quality
def readGasQuality():
    gas = str(chan.voltage)
    print("ADC Voltage: " + gas + "V")
    return gas

# Send SMS
def sendSMS():
    message = client.messages.create(
    from_='+12184026613',
    to='+919820077642',
    body= "GAS Leakage Detected",
    )

    print(message.sid)
    print("Sending SMS using Twilio")

# Click Image
def clickImage():
    print("Clicking Image")
    # Initialize camera
    camera = PiCamera()
    camera.resolution = (1024, 768)

    # Generate image path
    image_path = f'images/image_{datetime.datetime.now().isoformat()}.jpg'

    # Capture image
    camera.start_preview()
    sleep(2)  # Camera warm-up time
    camera.capture(image_path)
    camera.stop_preview()
    camera.close()
    
    # Upload to Firebase Storage
    bucket = storage.bucket()
    blob = bucket.blob(image_path)
    blob.upload_from_filename(image_path)
    print(f'Image uploaded to {image_path}')
    
    # # Generate a URL to access the image
    # url = blob.generate_signed_url(datetime.timedelta(seconds=300), method='GET')  # URL valid for 5 minutes
    # print(f'Access URL: {url}\n')
    
    public_url = f'https://firebasestorage.googleapis.com/v0/b/{bucket_name}/o/{image_path.replace("/", "%2F")}?alt=media'

    return public_url

# Get all values from pi
def getAllData():
    print("getAlldata Called")
    data = document.get().to_dict()
    print("Completed | getAllData")
    print(data)
    return data

def readAndSetAllData(data):
    try:
        dht = readHumidityTemperature()
        data["hum"], data["temp"] = str(dht.humidity), str(dht.temperature)
    except Exception as e:
        print(f"Error reading humidity and temperature: {e}")

    try:
        data["dist"] = str(readDistance())
    except Exception as e:
        print(f"Error reading distance: {e}")

    try:
        data["leakage"] = str(readGasQuality())
    except Exception as e:
        print(f"Error reading gas quality: {e}")

    if iterations % 5 == 0:
        try:
            geoLocation = geocoder.ip('me')
            data["lat"] = str(geoLocation.latlng[0])
            data["long"] = str(geoLocation.latlng[1])
        except Exception as e:
            print(f"Error obtaining geolocation: {e}")

    try:
        document.set(data)
    except Exception as e:
        print(f"Error setting document data: {e}")

    return data

# Main Loop
while True:
    print("\nMain Loop Started")
    
    data = getAllData()
    
    if data['forward'] == True:
        forward()
    elif data['left'] == True:
        left()
    elif data['right'] == True:
        right()
    elif data['backward'] == True:
        backward()
    else:
        stop()
    
    if data["torch"] == True:
        GPIO.output(LED_PIN, GPIO.HIGH)
    else:
        GPIO.output(LED_PIN, GPIO.LOW)
    
    if iterations % 4 == 0 :
        if data["sms_enabled"] == True and float(data["leakage"]) > 1.5:
            try:
                sendSMS()
                data["sms_enabled"] = False
            except Exception as e:
                print("Error sending SMS: ", e)
        
        if data["click_image"] == True:
            try:
                imageUrl = clickImage()
                data["view_images"].append(imageUrl)
                data["click_image"] = False
            except Exception as e:
                print("Error clicking image: ", e)
        print(readAndSetAllData(data))

    iterations += 1
    print("Main Loop Ended:",iterations, end="\n")
    sleep(1)
    

