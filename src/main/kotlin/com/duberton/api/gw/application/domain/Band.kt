package com.duberton.api.gw.application.domain

data class Band(
    val id: String? = null,
    val name: String,
    val genre: String,
    val members: List<String>
)