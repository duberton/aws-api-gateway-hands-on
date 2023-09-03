package com.duberton.api.gw.adapter.cockroach.ext

import com.duberton.api.gw.adapter.cockroach.entity.BandEntity
import com.duberton.api.gw.application.domain.Band

fun Band.toEntity() = BandEntity(
    id = id, name = name, genre = genre, members = members
)

fun BandEntity.toDomain() = Band(
    id = id, name = name, genre = genre, members = members
)