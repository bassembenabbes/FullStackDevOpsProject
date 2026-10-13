package com.example.personnes;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

@Service
@Transactional
public class PersonneService {

    private final PersonneRepository repository;

    public PersonneService(PersonneRepository repository) {
        this.repository = repository;
    }

    @Transactional(readOnly = true)
    public List<Personne> findAll() {
        return repository.findAll(Sort.by("code"));
    }

    @Transactional(readOnly = true)
    public Personne get(String code) {
        return repository.findById(code).orElseThrow(() ->
                new ResponseStatusException(HttpStatus.NOT_FOUND, "Personne introuvable : " + code));
    }

    public Personne create(PersonneRequest r) {
        if (repository.existsById(r.code())) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Ce code existe déjà");
        }
        if (repository.existsByCin(r.cin())) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Ce CIN est déjà utilisé");
        }
        return repository.save(new Personne(r.code().trim(), r.name().trim(), r.cin()));
    }

    public Personne update(String code, PersonneRequest r) {
        Personne p = get(code);
        if (repository.existsByCinAndCodeNot(r.cin(), code)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Ce CIN est déjà utilisé");
        }
        p.setName(r.name().trim());
        p.setCin(r.cin());
        return p;
    }

    public void delete(String code) {
        repository.delete(get(code));
    }
}
