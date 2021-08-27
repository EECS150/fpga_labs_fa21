from pynput.keyboard import Key, Listener
import os
import serial


if os.name == 'nt':
    print('Windows machine!')
    ser = serial.Serial()
    ser.baudrate = 115200
    ser.port = 'COM11' # CHANGE THIS COM PORT
    ser.open()
else:
    print('Not windows machine!')
    ser = serial.Serial('/dev/ttyUSB0')
    ser.baudrate = 115200

keys_pressed = set()

def on_press(key):
    if key not in keys_pressed:
        print('{0} pressed'.format(
            key))
        ser.write(bytearray([0x80]))
        ser.write(bytearray([ord(key.char)]))
    keys_pressed.add(key)
    if key == Key.esc:
        # Stop listener
        return False

def on_release(key):
    print('{0} release'.format(
        key))
    if key in keys_pressed:
        keys_pressed.remove(key)
        ser.write(bytearray([0x81]))
        ser.write(bytearray([ord(key.char)]))
    if key == Key.esc:
        # Stop listener
        return False

# Collect events until released
with Listener(
        on_press=on_press,
        on_release=on_release) as listener:
    listener.join()
