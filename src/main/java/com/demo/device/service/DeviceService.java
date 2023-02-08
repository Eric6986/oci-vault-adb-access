package com.demo.device.service;

import com.demo.device.dto.DeviceDTO;
import com.demo.device.dto.DevicesDTO;
import com.demo.device.model.Device;
import com.demo.device.oci.OciHelperBean;
import com.demo.device.repository.DeviceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.Optional;

@Service
public class DeviceService {

    @Autowired
    DeviceRepository repository;

    @Autowired
    OciHelperBean ociHelperBean;

    public ResponseEntity<Object> getAllDevices() {
        DevicesDTO devicesDTO = new DevicesDTO();
        try {
            for (Device device : repository.findAll()) {
                devicesDTO.addDevice(DeviceMapper.getDeviceDTO(device));
            }
        } catch (Throwable e) {
            e.printStackTrace();
        }
        return new ResponseEntity<>(devicesDTO, HttpStatus.OK);
    }

    public ResponseEntity<Object> getDeviceById(Integer id) {
        DeviceDTO deviceDTO = null;
        try {
            Optional<Device> device = repository.findById(id);
            if(device.isPresent()) {
                deviceDTO = DeviceMapper.getDeviceDTO(device.get());
            }
        } catch (Throwable e) {
            e.printStackTrace();
        }
        return new ResponseEntity<>(deviceDTO, HttpStatus.OK);
    }



    public ResponseEntity<Object> saveDevice(DeviceDTO deviceDTO) {
        Device device = DeviceMapper.getDevice(deviceDTO);
        try {
            device = repository.save(device);
	    ObjectMapper objectMapper = new ObjectMapper();
	    deviceDTO = DeviceMapper.getDeviceDTO(device);
        } catch (Throwable e) {
            e.printStackTrace();
        }
        return new ResponseEntity<>(deviceDTO, HttpStatus.OK);
    }

    public ResponseEntity<Object> updateDevice(DeviceDTO deviceDTO) {
        try {
            repository.save(DeviceMapper.getDevice(deviceDTO));
        } catch (Throwable e) {
            e.printStackTrace();
        }
        return new ResponseEntity<>(HttpStatus.OK);
    }

    public ResponseEntity<Object> deleteDevice(Integer id) {
        try {
            repository.deleteById(id);
        } catch (Throwable e) {
            e.printStackTrace();
        }
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);

    }

    public ResponseEntity<Object> getDevicesByUser(String userId) {
        DevicesDTO devicesDTO = new DevicesDTO();
        try {
            for (Device device : repository.findDevicesByUserId(userId)) {
                devicesDTO.addDevice(DeviceMapper.getDeviceDTO(device));
            }
        } catch (Throwable e) {
            e.printStackTrace();
        }
        return new ResponseEntity<>(devicesDTO, HttpStatus.OK);
    }
}
