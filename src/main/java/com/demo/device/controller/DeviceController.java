package com.demo.device.controller;

import com.demo.device.dto.DeviceDTO;
import com.demo.device.service.DeviceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.Map;
import java.util.logging.Logger;

@RestController
@CrossOrigin
public class DeviceController {
    final Logger logger = Logger.getLogger(DeviceController.class.getName());

    @Autowired
    DeviceService service;

    @GetMapping(path = "/devices")
    private ResponseEntity<Object> getAllDevices(
            @RequestHeader Map<String, String> headers) {
        final String uri = "[GET] /devices";
        ResponseEntity<Object> result = service.getAllDevices();
        return result;
    }

    @GetMapping(path = "/devices/user/{userId}")
    private ResponseEntity<Object> getDevicesByCustomer(
            @PathVariable("userId") String userId) {

        final String uri = "[GET] /devices/user/{userId}";
        ResponseEntity<Object> result = service.getDevicesByUser(userId);
        return result;
    }

    @GetMapping(path = "/devices/{id}")
    private ResponseEntity<Object> getDevice(
            @PathVariable("id") Integer id,
            @RequestHeader Map<String, String> headers) {
        final String uri = "[GET] /devices/{id}";
        ResponseEntity<Object> result = service.getDeviceById(id);
        return result;
    }

    @PostMapping(path = "/devices", produces = MediaType.APPLICATION_JSON_VALUE)
    private ResponseEntity<Object> createDevice(
            @RequestHeader Map<String, String> headers,
            @RequestBody DeviceDTO device) {
        final String uri = "[POST] /devices";
        ResponseEntity<Object> result = service.saveDevice(device);
        return result;
    }

    @PutMapping(path = "/devices", produces = MediaType.APPLICATION_JSON_VALUE)
    private ResponseEntity<Object> updateDevice(
            @RequestHeader Map<String, String> headers,
            @RequestBody DeviceDTO device) {

        final String uri = "[PUT] /devices";
        ResponseEntity<Object> result = service.updateDevice(device);
        return result;
    }
}
