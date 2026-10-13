package com.example.personnes;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "personne")
public class Personne {

    @Id
    @Column(name = "code", length = 20)
    private String code;

    @Column(name = "name", nullable = false, length = 100)
    private String name;

    @Column(name = "cin", nullable = false, unique = true, length = 8)
    private String cin;

    protected Personne() {}

    public Personne(String code, String name, String cin) {
        this.code = code;
        this.name = name;
        this.cin = cin;
    }

    public String getCode() { return code; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getCin() { return cin; }
    public void setCin(String cin) { this.cin = cin; }
}
