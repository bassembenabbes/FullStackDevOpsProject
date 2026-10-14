package com.example.personnes;

import static org.hamcrest.Matchers.containsString;
import static org.hamcrest.Matchers.hasSize;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.testcontainers.service.connection.ServiceConnection;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.testcontainers.containers.PostgreSQLContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;

/** Test d'intégration : vrai PostgreSQL démarré par Testcontainers (Docker requis). */
@SpringBootTest
@AutoConfigureMockMvc
@Testcontainers
class PersonneApiIntegrationTest {

    @Container
    @ServiceConnection
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:17");

    @Autowired
    MockMvc mvc;

    @Autowired
    PersonneRepository repository;

    @BeforeEach
    void clean() {
        repository.deleteAll();
    }

    private static String json(String code, String name, String cin) {
        return String.format("{\"code\":\"%s\",\"name\":\"%s\",\"cin\":\"%s\"}", code, name, cin);
    }

    private void creer(String code, String name, String cin) throws Exception {
        mvc.perform(post("/api/personnes").contentType(MediaType.APPLICATION_JSON).content(json(code, name, cin)))
                .andExpect(status().isCreated());
    }

    @Test
    void creer_puis_lister() throws Exception {
        creer("P002", "Sami", "22222222");
        creer("P001", "Ali", "11111111");

        mvc.perform(get("/api/personnes"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(2)))
                .andExpect(jsonPath("$[0].code").value("P001"))   // trié par code
                .andExpect(jsonPath("$[1].code").value("P002"));
    }

    @Test
    void creer_codeDuplique_retourne409() throws Exception {
        creer("P001", "Ali", "11111111");

        mvc.perform(post("/api/personnes").contentType(MediaType.APPLICATION_JSON)
                        .content(json("P001", "Autre", "99999999")))
                .andExpect(status().isConflict())
                .andExpect(jsonPath("$.fields.code").exists());
    }

    @Test
    void creer_cinDuplique_retourne409() throws Exception {
        creer("P001", "Ali", "11111111");

        mvc.perform(post("/api/personnes").contentType(MediaType.APPLICATION_JSON)
                        .content(json("P002", "Sami", "11111111")))
                .andExpect(status().isConflict())
                .andExpect(jsonPath("$.fields.cin").exists());
    }

    @Test
    void creer_donneesInvalides_retourne400() throws Exception {
        mvc.perform(post("/api/personnes").contentType(MediaType.APPLICATION_JSON)
                        .content(json("", "", "abc")))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.fields.code").exists())
                .andExpect(jsonPath("$.fields.name").exists())
                .andExpect(jsonPath("$.fields.cin").exists());
    }

    @Test
    void modifier_met_a_jour_nom_et_cin() throws Exception {
        creer("P001", "Ali", "11111111");

        mvc.perform(put("/api/personnes/P001").contentType(MediaType.APPLICATION_JSON)
                        .content(json("P001", "Ali Ben Salah", "33333333")))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.name").value("Ali Ben Salah"))
                .andExpect(jsonPath("$.cin").value("33333333"));
    }

    @Test
    void modifier_inconnu_retourne404() throws Exception {
        mvc.perform(put("/api/personnes/NOPE").contentType(MediaType.APPLICATION_JSON)
                        .content(json("NOPE", "X", "12345678")))
                .andExpect(status().isNotFound());
    }

    @Test
    void supprimer_puis_introuvable() throws Exception {
        creer("P001", "Ali", "11111111");

        mvc.perform(delete("/api/personnes/P001")).andExpect(status().isNoContent());
        mvc.perform(get("/api/personnes/P001")).andExpect(status().isNotFound());
    }

    @Test
    void sondeDeSante_repond() throws Exception {
        mvc.perform(get("/actuator/health/readiness")).andExpect(status().isOk());
    }

    @Test
    void prometheus_expose_des_metriques() throws Exception {
        mvc.perform(get("/actuator/prometheus"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("jvm_threads_live_threads")));
    }
}
