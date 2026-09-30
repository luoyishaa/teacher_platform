package com.fandou.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class AttachResourceDto {
    @NotNull
    private Long resourceId;
}
