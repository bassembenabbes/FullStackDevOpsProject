package com.example.personnes;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public record PersonneRequest(
        @NotBlank(message = "Le code est obligatoire")
        @Size(max = 20, message = "20 caractères maximum")
        String code,

        @NotBlank(message = "Le nom est obligatoire")
        @Size(max = 100, message = "100 caractères maximum")
        String name,

        @NotBlank(message = "Le CIN est obligatoire")
        @Pattern(regexp = "\\d{8}", message = "Le CIN doit contenir 8 chiffres")
        String cin) {
}
