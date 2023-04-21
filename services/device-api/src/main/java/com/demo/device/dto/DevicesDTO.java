package com.demo.device.dto;

import java.util.ArrayList;
import java.util.List;

public class DevicesDTO {
    List<DeviceDTO> devices = new ArrayList<>();
    public List<DeviceDTO> getDevices() {
        return devices;
    }
    public void addDevice(DeviceDTO deviceDTO) {
        devices.add(deviceDTO);
    }
}
