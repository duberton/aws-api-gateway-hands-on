package com.duberton.api.gw.adapter.output.cockroach.ext

import com.duberton.api.gw.adapter.output.cockroach.entity.BandEntity
import com.duberton.api.gw.application.domain.Band

fun Band.toEntity() = BandEntity(
    id = id, name = name, genre = genre, members = members, createdAt = createdAt
)

fun BandEntity.toDomain() = Band(
    id = id, name = name, genre = genre, members = members, createdAt = createdAt
)