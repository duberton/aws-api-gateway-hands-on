package com.duberton.api.gw.adapter.output.cockroach.entity

import org.springframework.data.annotation.Id
import org.springframework.data.relational.core.mapping.Table
import javax.persistence.GeneratedValue

@Table("band")
class BandEntity(
    @Id @GeneratedValue var id: String?,
    val name: String,
    val genre: String,
    val members: List<String>
)