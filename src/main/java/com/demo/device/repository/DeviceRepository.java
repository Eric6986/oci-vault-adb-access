package com.demo.device.repository;

import com.demo.device.model.Device;
import org.springframework.data.repository.CrudRepository;
import java.util.List;

public interface DeviceRepository extends CrudRepository<Device, Integer> {
    List<Device> findDevicesByUserId(String userId);
}
