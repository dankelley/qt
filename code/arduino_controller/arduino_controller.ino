// to test in controller, do e.g.:
//    cat  /dev/cu.usbmodem1421
// and it should output temperature and rel humidity repeatedly
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

uint32_t delayMS;

void setup() {
    Serial.begin(9600); 
    dht.begin();
    sensor_t sensor;
    //dht.temperature().getSensor(&sensor);
    dht.temperature().getSensor(&sensor);
    delayMS = sensor.min_delay / 1000;
    //Serial.print("delayMS ");
    //Serial.println(delayMS);
}

void loop() {
    int SAMPLES = 10; // do some averaging and slow things down a bit
    int nt = 0, nq = 0;
    float t = 0.0, q = 0.0;
    for (int i = 0; i < SAMPLES; i++) {
        digitalWrite(pinLED, HIGH);
        delay(delayMS);
        digitalWrite(pinLED, LOW);
        sensors_event_t event;  
        dht.temperature().getEvent(&event);
        if (!isnan(event.temperature)) {
            t += event.temperature;
            nt += 1;
        }
        dht.humidity().getEvent(&event);
        if (!isnan(event.relative_humidity)) {
            q += event.relative_humidity;
            nq += 1;
        }
    }
    if (nt > 0) t /= nt;
    else t = -999.0;
    if (nq > 0) q /= nq;
    else q = -999.0;
    Serial.print(t);
    Serial.print(" ");
    Serial.println(q);
}

