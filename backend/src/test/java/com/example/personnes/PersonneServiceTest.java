package com.example.personnes;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.Optional;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;

@ExtendWith(MockitoExtension.class)
class PersonneServiceTest {

    @Mock
    PersonneRepository repository;

    @InjectMocks
    PersonneService service;

    private static PersonneRequest request(String code, String name, String cin) {
        return new PersonneRequest(code, name, cin);
    }

    @Test
    void create_enregistreLaPersonneSansEspacesParasites() {
        when(repository.save(any(Personne.class))).thenAnswer(i -> i.getArgument(0));

        Personne p = service.create(request(" P001 ", "  Ali Ben Salah ", "12345678"));

        assertThat(p.getCode()).isEqualTo("P001");
        assertThat(p.getName()).isEqualTo("Ali Ben Salah");
        assertThat(p.getCin()).isEqualTo("12345678");
    }

    @Test
    void create_codeExistant_leveConflit() {
        when(repository.existsById("P001")).thenReturn(true);

        ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> service.create(request("P001", "Ali", "12345678")));

        assertThat(ex.getStatusCode()).isEqualTo(HttpStatus.CONFLICT);
        verify(repository, never()).save(any());
    }

    @Test
    void create_cinExistant_leveConflit() {
        when(repository.existsByCin("12345678")).thenReturn(true);

        ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> service.create(request("P002", "Sami", "12345678")));

        assertThat(ex.getStatusCode()).isEqualTo(HttpStatus.CONFLICT);
        verify(repository, never()).save(any());
    }

    @Test
    void get_inconnu_leve404() {
        when(repository.findById("X")).thenReturn(Optional.empty());

        ResponseStatusException ex = assertThrows(ResponseStatusException.class, () -> service.get("X"));

        assertThat(ex.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);
    }

    @Test
    void update_modifieNomEtCin() {
        Personne existante = new Personne("P001", "Ancien", "11111111");
        when(repository.findById("P001")).thenReturn(Optional.of(existante));
        when(repository.existsByCinAndCodeNot("22222222", "P001")).thenReturn(false);

        Personne p = service.update("P001", request("P001", "Nouveau", "22222222"));

        assertThat(p.getName()).isEqualTo("Nouveau");
        assertThat(p.getCin()).isEqualTo("22222222");
    }

    @Test
    void update_cinDejaPrisParUnAutre_leveConflit() {
        when(repository.findById("P001")).thenReturn(Optional.of(new Personne("P001", "Ali", "11111111")));
        when(repository.existsByCinAndCodeNot("22222222", "P001")).thenReturn(true);

        ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> service.update("P001", request("P001", "Ali", "22222222")));

        assertThat(ex.getStatusCode()).isEqualTo(HttpStatus.CONFLICT);
    }

    @Test
    void delete_supprimeLaPersonne() {
        Personne p = new Personne("P001", "Ali", "11111111");
        when(repository.findById("P001")).thenReturn(Optional.of(p));

        service.delete("P001");

        verify(repository).delete(p);
    }
}
