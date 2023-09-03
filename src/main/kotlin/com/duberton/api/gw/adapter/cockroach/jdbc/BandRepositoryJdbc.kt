package com.duberton.api.gw.adapter.cockroach.jdbc

import com.duberton.api.gw.adapter.cockroach.entity.BandEntity
import org.springframework.data.domain.Pageable
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Repository

@Repository
interface BandRepositoryJdbc : CrudRepository<BandEntity, String> {

    fun findAll(pageable: Pageable): List<BandEntity>

}