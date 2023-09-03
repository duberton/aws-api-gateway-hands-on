package com.duberton.api.gw.adapter.cockroach.config

import com.duberton.api.gw.adapter.cockroach.BandRepository
import com.duberton.api.gw.adapter.cockroach.jdbc.BandRepositoryJdbc
import org.postgresql.ds.PGSimpleDataSource
import org.springframework.beans.factory.annotation.Value
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration

@Configuration
class CockroachConfig {

    @Value("\${cockroach.db.url}")
    private lateinit var url: String

    @Value("\${cockroach.db.user}")
    private lateinit var user: String

    @Value("\${cockroach.db.password}")
    private lateinit var password: String

    @Bean
    fun cockroach(): PGSimpleDataSource {
        val database = PGSimpleDataSource();
        database.setUrl(url)
        database.user = user
        database.password = password
        return database
    }

    @Bean
    fun bandRepository(bandRepositoryJdbc: BandRepositoryJdbc) = BandRepository(bandRepositoryJdbc)

}