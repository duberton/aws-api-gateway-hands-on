package com.duberton.api.gw.adapter.cockroach

import com.duberton.api.gw.adapter.cockroach.ext.toDomain
import com.duberton.api.gw.adapter.cockroach.ext.toEntity
import com.duberton.api.gw.adapter.cockroach.jdbc.BandRepositoryJdbc
import com.duberton.api.gw.application.domain.Band
import com.duberton.api.gw.application.port.output.BandRepositoryPort
import org.springframework.data.domain.PageRequest
import kotlin.jvm.optionals.getOrNull

class BandRepository(private val bandRepositoryJdbc: BandRepositoryJdbc) : BandRepositoryPort {

    override fun save(band: Band) = bandRepositoryJdbc.save(band.toEntity()).toDomain()

    override fun findById(id: String) = bandRepositoryJdbc.findById(id).getOrNull()?.toDomain()

    override fun findAll(offset: Int, page: Int) =
        bandRepositoryJdbc.findAll(PageRequest.of(offset, page)).map { it.toDomain() }

    override fun delete(id: String) = bandRepositoryJdbc.deleteById(id)
}