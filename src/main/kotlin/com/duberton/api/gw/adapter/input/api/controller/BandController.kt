package com.duberton.api.gw.adapter.input.api.controller

import com.duberton.api.gw.adapter.input.api.BandApi
import com.duberton.api.gw.adapter.input.api.ext.toDomain
import com.duberton.api.gw.adapter.input.api.ext.toResponse
import com.duberton.api.gw.adapter.input.api.request.BandRequest
import com.duberton.api.gw.adapter.input.api.response.BandResponse
import com.duberton.api.gw.application.port.output.DeleteBandPort
import com.duberton.api.gw.application.port.output.FindBandByIdPort
import com.duberton.api.gw.application.port.output.FindBandsPort
import com.duberton.api.gw.application.port.output.SaveBandPort
import org.springframework.web.bind.annotation.RestController

@RestController
class BandController(
    private val saveBandPort: SaveBandPort,
    private val findBandByIdPort: FindBandByIdPort,
    private val deleteBandPort: DeleteBandPort,
    private val findBandsPort: FindBandsPort
) : BandApi {

    override fun createBand(request: BandRequest): BandResponse {
        return saveBandPort.save(request.toDomain()).toResponse()
    }

    override fun bands(offset: Int, page: Int): List<BandResponse> {
        return findBandsPort.execute(offset, page).map { it.toResponse() }
    }

    override fun band(bandId: String): BandResponse? {
        return findBandByIdPort.execute(bandId)?.toResponse()
    }

    override fun deleteBand(bandId: String) {
        deleteBandPort.execute(bandId)
    }
}