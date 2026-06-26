```
pip install nodemcu-uploader esptool
```

* esptool.py is used to update firmware
```
sudo esptool.py --port /dev/cu.usbserial-0001 write_flash -fm qio 0x0000 nodemcu-release-9-modules-2024-12-02-06-38-55-float.bin
```

* nodemcu-uploader is used to upload files

```
alias cu=nodemcu-uploader
```


