#include <SoftwareSerial.h>
#include <stdlib.h>
#include <string.h>

SoftwareSerial bt(2, 3); /* (Rx,Tx) */

int page = 0;
int power = 255;
int tempPower = power;
int bleYes = 0;

String buff;

void decCurrentConst(int del, int bleYes)
{
    for (int i = power; i >= 0 && bleYes == 0; i--)
    {
        analogWrite(A0, i);
        Serial.println(i);
        delay(del);
    }
}
void incCurrentConst(int del, int bleYes)
{
    for (int i = 0; i <= power && bleYes == 0; i++)
    {
        Serial.println(i);

        analogWrite(A0, i);
        delay(del);
    }
}

void setDirectionAll(int dir)
{
    for (int i = 4; i <= 8; i++)
    {
        digitalWrite(i, dir);
    }
}

void getParams(String str, int nums[])
{
    int curr = 0;
    int counter = 0;

    for (int i = 0; i < str.length(); i++)
    {
        if ((int)str[i] >= 48 && (int)str[i] <= 57)
        {
            curr = curr * 10 + ((int)str[i] - 48);
        }
        else if ((int)str[i] == 35)
        {
            nums[counter] = curr;
            counter++;
            curr = 0;
        }
    }
}

void setup()
{
    bt.begin(9600);     /* Define baud rate for software serial communication */
    Serial.begin(9600); /* Define baud rate for serial communication */

    for (int i = 4; i <= 13; i++)
    {
        pinMode(i, OUTPUT);
    }

    pinMode(A0, OUTPUT);

    for (int i = 4; i <= 8; i++)
    {
        digitalWrite(i, 0);
    }

    for (int i = 9; i <= 13; i++)
    {
        digitalWrite(i, 0);
    }

    analogWrite(A0, 255);
}

void loop()
{

    if (bt.available() || bleYes == 1)
    {
        String inst;
        if (bleYes == 1)
        {
            inst = buff;
            buff = "";
            bleYes = 0;
            Serial.println("in bleyes");
            Serial.println(inst);
        }
        else
        {
            inst = bt.readStringUntil('\n');
        }

        int nums[100];
        getParams(inst, nums);

        if (nums[0] == 1)
        {
            power = (nums[1] * 255) / 100;
            tempPower = power;
            analogWrite(A0, power);
        }
        else if (nums[0] == 2)
        {
            page = nums[1];
        }
        else if (nums[0] == 3)
        {
            power = tempPower * nums[1];
            analogWrite(A0, power);
        }
        else if (nums[0] == 4)
        {
        }
        else if (nums[0] == 5)
        {
        }
        else if (nums[0] == 6)
        {
            // decCurrentConst(10, bleYes);
            analogWrite(A0, 0);
            delay(500);
            for (int i = 1; i < 6; i++)
            {
                digitalWrite(8 + i, nums[i]);
            }
            delay(500);
            analogWrite(A0, 255);
            // incCurrentConst(10, bleYes);
        }
    }

    if (page == 0)
    {
        setDirectionAll(0);
        // analogWrite(A0, power);
        incCurrentConst(2, bleYes);
        for (int i = 0; i < 5000 && bleYes == 0; i++)
        {
            if (bt.available())
            {
                buff = bt.readStringUntil('\n');
                Serial.println(buff);
                Serial.println("plij1");

                for (int x = 0; x < buff.length(); x++)
                {
                    if ((int)buff[x] <= 54 && (int)buff[x] >= 49)
                    {
                        buff = buff.substring(x, buff.length() - 1);
                        bleYes = 1;
                        break;
                    }
                }
            }
            delay(1);
        }
        decCurrentConst(2, bleYes);
        setDirectionAll(1);

        incCurrentConst(2, bleYes);

        // analogWrite(A0, 255);
        for (int i = 0; i < 5000 && bleYes == 0; i++)
        {
            if (bt.available())
            {
                buff = bt.readStringUntil('\n');
                Serial.println(buff);
                Serial.println("plij2");
                if ((int)buff[0] <= 54 && (int)buff[0] >= 49)
                {
                    bleYes = 1;
                    // break;
                }
            }
            delay(1);
        }
        decCurrentConst(2, bleYes);
    }
    // incCurrentConst(100, bleYes);
    // delay(1000);
    // decCurrentConst(100, bleYes);
    // delay(1000);
    // analogWrite(A0, 255);
}