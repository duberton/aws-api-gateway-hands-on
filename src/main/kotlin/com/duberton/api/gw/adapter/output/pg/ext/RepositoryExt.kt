package com.duberton.api.gw.adapter.output.cockroach.ext

import com.duberton.api.gw.adapter.output.cockroach.entity.BandEntity
import com.duberton.api.gw.application.domain.Band
import java.time.LocalDateTime

fun Band.toEntity() = BandEntity(
    name = name, genre = genre, members = members, createdAt = LocalDateTime.parse(createdAt)
)

fun BandEntity.toDomain() = Band(
    id = id.toString(), name = name, genre = genre, members = members, createdAt = createdAt.toString()
)