package com.novasys.backend;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * Entry point for the NovaSys backend.
 *
 * <p>This is foundation setup only: it starts an empty Spring Boot application
 * with JPA, validation and an H2 development database wired up, plus the
 * Actuator health endpoint. Domain features are added in later work.
 */
@SpringBootApplication
public class NovasysBackendApplication {

    public static void main(String[] args) {
        SpringApplication.run(NovasysBackendApplication.class, args);
    }
}
