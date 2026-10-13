package com.example.personnes;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/personnes")
public class PersonneController {

    private final PersonneService service;

    public PersonneController(PersonneService service) {
        this.service = service;
    }

    @GetMapping
    public List<Personne> list() {
        return service.findAll();
    }

    @GetMapping("/{code}")
    public Personne get(@PathVariable String code) {
        return service.get(code);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Personne create(@Valid @RequestBody PersonneRequest request) {
        return service.create(request);
    }

    @PutMapping("/{code}")
    public Personne update(@PathVariable String code, @Valid @RequestBody PersonneRequest request) {
        return service.update(code, request);
    }

    @DeleteMapping("/{code}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(@PathVariable String code) {
        service.delete(code);
    }
}
