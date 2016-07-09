// to test in controller, do e.g.:
//    cat  /dev/cu.usbmodem1421
// and it should output temperature and rel humidity repeatedly, on a 10s interval.

// Alter next line to change the default sampling interval in milliseconds,
// e.g. 30000 means to sample twice per minute.
#define DEFAULT_SAMPLING_INTERVAL 30000
#include <DHT.h>

#include <Adafruit_Sensor.h>
#include <DHT.h>
#include <DHT_U.h>

int pinLED = 13;
#define DHTPIN            5         // Pin which is connected to the DHT sensor.

//#define DHTTYPE           DHT11     // DHT 11 
#define DHTTYPE           DHT22     // DHT 22 (AM2302)
//#define DHTTYPE           DHT21     // DHT 21 (AM2301)

DHT_Unified dht(DHTPIN, DHTTYPE);

uint32_t delaySensorMS; // typically 2000 ms
uint32_t delayMS;   // set to 10,000 ms since we don't need really rapid data flow

void setup() {
    Serial.begin(9600); 
    dht.begin();
    sensor_t sensor;
    //dht.temperature().getSensor(&sensor);
    dht.temperature().getSensor(&sensor);
    delaySensorMS = sensor.min_delay / 1000;
    // for DHT22 delayMS will be 2000 (milliseconds)
    if (delaySensorMS < DEFAULT_SAMPLING_INTERVAL)
        delayMS = DEFAULT_SAMPLING_INTERVAL;
    else
        delayMS = delaySensorMS;
    // Serial.print("delaySensorMS ");
    // Serial.println(delaySensorMS);
    // Serial.print("delayMS ");
    // Serial.println(delayMS);
}

void loop() {
    float t = -999.0, q = -999.0;
    digitalWrite(pinLED, HIGH);
    delay(delayMS);
    digitalWrite(pinLED, LOW);
    sensors_event_t event;  
    dht.temperature().getEvent(&event);
    if (!isnan(event.relative_humidity))
        t = event.temperature;
    dht.humidity().getEvent(&event);
    if (!isnan(event.relative_humidity)) 
        q = event.relative_humidity;
    Serial.print(t);
    Serial.print(" ");
    Serial.println(q);
}

