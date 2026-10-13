package com.example.personnes;

import org.springframework.data.jpa.repository.JpaRepository;

public interface PersonneRepository extends JpaRepository<Personne, String> {
    boolean existsByCin(String cin);
    boolean existsByCinAndCodeNot(String cin, String code);
}
