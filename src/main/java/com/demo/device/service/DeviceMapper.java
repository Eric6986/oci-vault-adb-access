package com.demo.device.service;

import com.demo.device.dto.DeviceDTO;
import com.demo.device.model.Device;
import org.springframework.beans.BeanUtils;

public class DeviceMapper {
    public static DeviceDTO getDeviceDTO(Device device) {
        DeviceDTO deviceDTO = new DeviceDTO();
        BeanUtils.copyProperties(device, deviceDTO);
        return deviceDTO;
    }

    public static Device getDevice(DeviceDTO deviceDTO) {
        Device device = new Device();
        BeanUtils.copyProperties(deviceDTO, device);
        return device;
    }
}
