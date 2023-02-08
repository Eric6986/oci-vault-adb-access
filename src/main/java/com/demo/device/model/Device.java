package com.demo.device.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "DEVICES")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Device {
    @Id
    @Column(name = "DEVICE_ID")
    Integer deviceId;
    @Column(name = "USER_ID")
    String userId;
    @Column(name = "DEVICE_TYPE")
    String deviceType;
    @Column(name = "DEVICE_MODEL")
    String deviceModel;
    @Column(name = "DEVICE_ONLINE_DATE")
    @Temporal(TemporalType.TIMESTAMP)
    Date deviceOnlineDate;
    @Column(name = "DEVICE_REGISTER_DATE")
    @Temporal(TemporalType.DATE)
    Date deviceRegisterDate;
}