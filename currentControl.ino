#include <SoftwareSerial.h>
#include <stdlib.h>
#include <string.h>

SoftwareSerial bt(2, 3); // (Rx,Tx)

int RPWM = 5;
int LPWM = 6;

int L_EN = 7;
int R_EN = 8;

int page = 0;
int power = 0;
int tempPower = power;
int bleYes = 0;
int isPlaying = 0;

int states[15][5];
int seconds[15];
int numOfSteps = 1;

int oneRelPins[5] = {A1, A2, A3, A4, A5};

String buff;

void decCurrentConst(int del)
{
    // Serial.println(power);

    for (int i = 255; i > power; i--)
    {
        delay(del);
    }
    for (int i = power; i >= 0 && bleYes == 0; i--)
    {
        analogWrite(RPWM, i);
        delay(del);
    }
}
void incCurrentConst(int del)
{
    // Serial.println(power);
    for (int i = 0; i < power && bleYes == 0; i++)
    {
        analogWrite(RPWM, i);
        delay(del);
    }

    for (int i = power; i < 256; i++)
    {
        delay(del);
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

void myDelay(int duration)
{
    for (int i = 0; i < duration && bleYes == 0; i++)
    {
        if (bt.available())
        {
            buff = bt.readStringUntil('\n');

            for (int x = 0; x < buff.length(); x++)
            {
                if ((int)buff[x] <= 54 && (int)buff[x] >= 49)
                {
                    buff = buff.substring(x, buff.length());
                    bleYes = 1;
                    break;
                }
            }
        }
        delay(1);
    }
}

void decodeStates(int nums[])
{
    for (int i = 3; i < 18; i++)
    {
        int temp = nums[i];
        int d = 16;
        int idx = 4;
        while (d > 0)
        {
            if (temp >= d)
            {
                temp = temp - d;
                states[i - 3][idx] = 1;
            }
            else
            {
                states[i - 3][idx] = 0;
            }
            d = d / 2;
            idx--;
        }
        int x = states[i - 3][3];
        states[i - 3][3] = states[i - 3][4];
        states[i - 3][4] = x;
    }
}

void decodeSeconds(int nums[])
{
    for (int i = 13; i < 33; i++)
    {
        seconds[i - 18] = nums[i];
    }
}

void setup()
{
    bt.begin(9600);
    Serial.begin(9600);

    for (int i = 4; i <= 13; i++)
    {
        pinMode(i, OUTPUT);
    }

    pinMode(A0, OUTPUT);

    for (int i = 4; i <= 8; i++)
    {
        digitalWrite(i, 0);
    }

    for (int i = 0; i < 5; i++)
    {
        analogWrite(oneRelPins[i], 255);
    }

    digitalWrite(R_EN, HIGH);
    digitalWrite(L_EN, HIGH);

    for (int i = 0; i < 15; i++)
    {
        for (int j = 0; j < 5; j++)
        {
            states[i][j] = 0;
        }
    }

    for (int i = 0; i < 15; i++)
    {
        seconds[i] = 0;
    }

    for (int i = 9; i <= 13; i++)
    {
        digitalWrite(i, 0);
    }
}

void loop()
{
    // analogWrite(RPWM, 0);
    // delay(400);
    // for(int i = 9; i <= 13; i++){
    //   digitalWrite(i, 1);
    // }
    // analogWrite(RPWM, power);
    // delay(2000);
    // analogWrite(RPWM, 0);
    // delay(400);
    // for(int i = 9; i <= 13; i++){
    //   digitalWrite(i, 0);
    // }
    // analogWrite(RPWM, power);
    // digitalWrite(10, 0);

    // delay(2000);

    // return;

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
        Serial.println(inst);

        int nums[40];
        getParams(inst, nums);

        if (nums[0] == 1)
        {
            Serial.print("num percentage : ");
            Serial.println(nums[1]);
            power = (nums[1] * 255) / 100;
            tempPower = power;
            analogWrite(RPWM, power);
        }
        else if (nums[0] == 2)
        {
            page = nums[1];
        }
        else if (nums[0] == 3)
        {
            power = tempPower * nums[1];
            analogWrite(RPWM, power);
        }
        else if (nums[0] == 4)
        {
        }
        else if (nums[0] == 5)
        {
            numOfSteps = nums[1];
            decodeStates(nums);
            decodeSeconds(nums);

            for (int i = 0; i < 15; i++)
            {
                Serial.println(seconds[i]);
            }

            isPlaying = nums[2];
        }
        else if (nums[0] == 6)
        {
            decCurrentConst(1);
            // delay(50);
            for (int i = 1; i < 6; i++)
            {
                analogWrite(oneRelPins[i - 1], (nums[i] == 1) ? 255 : 0);
            }

            incCurrentConst(1);
        }
    }

    if (page == 0)
    {

        Serial.println("in page 0");

        for (int i = 9; i <= 13; i++)
        {
            digitalWrite(i, 0);
        }

        analogWrite(RPWM, power);
        myDelay(4400);

        analogWrite(RPWM, 0);
        myDelay(400);

        for (int i = 9; i <= 13; i++)
        {
            digitalWrite(i, 1);
        }
        myDelay(400);

        analogWrite(RPWM, power);
        myDelay(2400);

        analogWrite(RPWM, 0);
        myDelay(400);
    }

    else
    {
        if (isPlaying == 1)
        {
            // for(int i = 0; i <= 5; i++){
            //   analogWrite(oneRelPins[i], 0);
            // }
            analogWrite(A1, 255);
            analogWrite(A2, 255);
            analogWrite(A3, 255);
            analogWrite(A4, 255);
            analogWrite(A5, 255);

            Serial.println("play on");
            for (int i = 0; i < numOfSteps && bleYes == 0; i++)
            {
                Serial.print("Step number : ");
                Serial.println(i);
                analogWrite(RPWM, 0);
                myDelay(400);
                for (int j = 9; j <= 13; j++)
                {
                    digitalWrite(j, 1 - states[i][j - 9]);
                }
                myDelay(400);

                analogWrite(RPWM, power);
                myDelay(seconds[i] * 1000);
            }
        }
        else
        {
            Serial.println("play off");

            myDelay(2000);
        }
    }
}