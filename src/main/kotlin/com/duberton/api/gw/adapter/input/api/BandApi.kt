package com.duberton.api.gw.adapter.input.api

import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping

@RequestMapping("/v1/bands")
interface BandApi {

    @GetMapping
    fun bands()

}