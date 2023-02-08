package com.demo.device.dto;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.*;
import java.util.Date;

@Getter
@Setter
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DeviceDTO {
    Integer deviceId;
    String userId;
    String deviceType;
    String deviceModel;
    Date deviceOnlineDate;
    Date deviceRegisterDate;

    public DeviceDTO(String json) throws JsonProcessingException {

        DeviceDTO deviceDTO = new ObjectMapper().readValue(json, DeviceDTO.class);

        this.deviceId = deviceDTO.getDeviceId();
        this.userId = deviceDTO.getUserId();
        this.deviceType = deviceDTO.getDeviceType();
        this.deviceModel = deviceDTO.getDeviceModel();
        this.deviceOnlineDate = deviceDTO.getDeviceOnlineDate();
        this.deviceRegisterDate = deviceDTO.getDeviceRegisterDate();
    }
}
