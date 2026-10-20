package com.novasys.backend;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.ApplicationContext;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Verifies that the Spring application context starts, which also proves the
 * H2 datasource and JPA/Hibernate configuration are valid.
 */
@SpringBootTest
class NovasysBackendApplicationTests {

    @Autowired
    private ApplicationContext applicationContext;

    @Test
    void contextLoads() {
        assertThat(applicationContext).isNotNull();
    }

    @Test
    void dataSourceIsConfigured() {
        assertThat(applicationContext.containsBean("dataSource")).isTrue();
    }
}
