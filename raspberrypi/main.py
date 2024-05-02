import firebase_admin
from firebase_admin import credentials
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
import requests


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
GPIO.setup(PWMA, GPIO.OUT)
GPIO.setup(AIN1, GPIO.OUT)
GPIO.setup(AIN2, GPIO.OUT)
GPIO.setup(PWMB, GPIO.OUT)
GPIO.setup(BIN1, GPIO.OUT)
GPIO.setup(BIN2, GPIO.OUT)

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
cred = credentials.Certificate('serviceAccountKey.json')
firebase_admin.initialize_app(cred)
# Create a Cloud Firestore client
database = firestore.client()
collection = database.collection("wheels")

print(collection)

############# Setup Complete #############


# Get the controller
def getController():
    try:
        controller = collection.document('controller').get().to_dict()
    except Exception as e:
        print(f"An error occurred: {e}")
    #print(controller)
    return controller

# Set the controller
def setController(left, forward, behind, right):
    collection.document('controller').set({'left': left, 'forward': forward, 'behind': behind, 'right': right})
    return
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

# Set the temperature and humidity
def setHumidityTemperature(dhtValue):
    collection.document('temperature').set({'temp': str(dhtValue.temperature), 'hum': str(dhtValue.humidity)})
    collection.document('humidity').set({'temp': str(dhtValue.temperature), 'hum': str(dhtValue.humidity)})
    return

# Read the temperature and humidity
def readHumidityTemperature():
    result = instance.read()
    if result.is_valid():
        print("Temp: %d C" % result.temperature +' '+"Humid: %d %%" % result.humidity)
        setHumidityTemperature(result)
        return result
    
# Read the distance
def readDistance():
    distance = sensor.distance
    print("Distance: %.1f cm" % (distance * 100))
    if distance < 0.06:
        stop()
    return distance

# Set the distance
def setDistance(dist):
    collection.document('distance').set({'dist': dist})
    return

# Read the Gas Quality
def readGasQuality():
    gas = str(chan.voltage)
    print("ADC Voltage: " + gas + "V")
    return gas

# Set the Gas Quality
def setGasQuality(gas):
    collection.document('leakage').set({'leakage': gas})
    return

# Detect Gas Leakage using ML model
def detectGasLeakage() -> str:
    '''Returns `yes` if there is leakage, `no` otherwise.'''
    result = instance.read()
    temperature = float(result.temperature)
    humidity = float(result.humidity)
    lpg = float(str(chan.voltage))
    leakage_value = "no"

    api_url = f"https://miniature-xylophone-wxqrpj94596fqrv-8000.app.github.dev/predict-leakage?temperature={temperature}&humidity={humidity}&lpg={lpg}" 

    try:
        response = requests.get(api_url)

        if response.status_code == 200:
            prediction_data = response.json()
            leakage_value = prediction_data["leakage"]

            print(f"Leakage: {leakage_value}")
            return leakage_value
        else:
            print(f"Error: API request failed with status code {response.status_code}")
            return leakage_value
    except Exception as e:
        print(f"An error occurred: {e}")
        return leakage_value


iterations = 0
# Main Loop
while True:
    print("Main Loop Started")
    controller = getController()
    if controller['forward'] == True:
        forward()
    elif controller['left'] == True:
        left()
    elif controller['right'] == True:
        right()
    elif controller['behind'] == True:
        backward()
    else:
        stop()
    
    setDistance(readDistance())
    readHumidityTemperature()
    readGasQuality()
    setGasQuality(detectGasLeakage())
    
    iterations += 1
    print("Main Loop Ended:",iterations)
    sleep(0.5)