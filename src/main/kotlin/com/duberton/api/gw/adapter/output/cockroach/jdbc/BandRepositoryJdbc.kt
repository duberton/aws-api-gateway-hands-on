package com.duberton.api.gw.adapter.output.cockroach.jdbc

import com.duberton.api.gw.adapter.output.cockroach.entity.BandEntity
import org.springframework.data.repository.CrudRepository
import org.springframework.data.repository.PagingAndSortingRepository
import org.springframework.stereotype.Repository

@Repository
interface BandRepositoryJdbc : CrudRepository<BandEntity, String>, PagingAndSortingRepository<BandEntity, String>