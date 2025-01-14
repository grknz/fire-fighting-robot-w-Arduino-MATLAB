a = arduino();

enA = 'D10';
in1 = 'D9';
in2 = 'D8';
in3 = 'D7';
in4 = 'D6';
inB = 'D5';
buzzer = 'D4';

ir_R = 'A0';
ir_F = 'A1';
ir_l = 'A2';

servoPin = 'A3';
pump = 'A5';

Speed = 190;

writePWMDutyCycle(a, servoPin, 0.5);

configurePin(a, ir_R, 'AnalogInput');
configurePin(a, ir_F, 'AnalogInput');
configurePin(a, ir_L, 'AnalogInput');

configurePin(a, enA, 'AnalogInput');
configurePin(a, enB, 'AnalogInput');
configurePin(a, in1, 'AnalogInput');
configurePin(a, in2, 'AnalogInput');
configurePin(a, in3, 'AnalogInput');
configurePin(a, in4, 'AnalogInput');
configurePin(a, buzzer, 'AnalogInput');
configurePin(a, pump, 'AnalogInput');

for angle = 90:5:140
    servoPulse(a, servoPin, angle);
end
for angle = 140:-5:40
    servoPulse(a, servoPin, angle);
end
for angle = 40:5:95
    servoPulse(a, servoPin, angle);
end

writePWMDutyCycle(a, enA, Speed / 255);
writePWMDutyCycle(a, enB, Speed / 255);

pause(0.5);

while true
    s1 = readVoltage(a, ir_R);
    s2 = readVoltage(a, ir_F);
    s3 = readVoltage(a, ir_L);

    disp([s1, s2, s3]);

    pause(0.05);

    if s1<0.8
        Stop(a, in1, in2, in3, in4);
        writeDigitalPin(a, pump, 1);

        for angle = 90:-2:40
            servoPulse(a, servoPin, angle);
        end
        for angle = 40:3:90
            servoPulse(a, servoPin, angle);
        end

    elseif s2 < 0.8
        Stop(a, in1, in2, in3, in4);
        writeDigitalPin(a, pump, 1);

        for angle = 90:3:140
            servoPulse(a, servoPin, angle);
        end
        for angle = 140:-3:40
            servoPulse(a, servoPin, angle);
        end
        for angle = 40:3:90
            servoPulse(a, servoPin, angle);

        elseif s3 < 0.8
            Stop(a, in1, in2, in3, in4);
            writeFigitalPin(a, pump, 1):

            for angle = 90:3:140
                servoPulse(a, servoPin, angle);
            end
            for angle = 140:-3:90
                servoPulse(a, servoPin, angle);
            end

        else
            writeDigitalPin(a, pump, 0);
            Stop(a, in1, in2, in3, in4);
        end
        pause(0.01);
    end

function servoPulse(a, pin, angle)
    pwm = (angle * 11 + 500) / 1e6;
    writePWMDutyCycle(a, pin, pwm);
    pause(0.05);
end

function Stop(a, in1, in2, in3, in4)
    writeDigitalPin(a, in1, 0);
    writeDigitalPin(a, in2, 0);
    writeDigitalPin(a, in3, 0);
    writeDigitalPin(a, in4, 0);
end
