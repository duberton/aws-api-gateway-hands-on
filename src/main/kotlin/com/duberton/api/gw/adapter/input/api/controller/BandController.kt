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
import com.duberton.api.gw.common.log.Logging
import org.springframework.web.bind.annotation.RestController

@RestController
class BandController(
    private val saveBandPort: SaveBandPort,
    private val findBandByIdPort: FindBandByIdPort,
    private val deleteBandPort: DeleteBandPort,
    private val findBandsPort: FindBandsPort
) : BandApi, Logging {

    override fun createBand(request: BandRequest): BandResponse {
        logger.info("Creating a band {}", request.name)
        val response = saveBandPort.save(request.toDomain()).toResponse()
        logger.info("Finished creating a band {}", response.name)
        return response
    }

    override fun bands(offset: Int, page: Int): List<BandResponse> {
        logger.info("Finding bands with offset {} and page {}", offset, page)
        val bandsResponse = findBandsPort.execute(offset, page).map { it.toResponse() }
        logger.info("Finished finding bands. Found {} bands", bandsResponse.size)
        return bandsResponse
    }

    override fun band(bandId: String): BandResponse? {
        logger.info("Finding band by id {}", bandId)
        val bandResponse = findBandByIdPort.execute(bandId)?.toResponse()
        logger.info("Found band by id {}", bandId)
        return bandResponse
    }

    override fun deleteBand(bandId: String) {
        logger.info("Deleting a band by id {}", bandId)
        deleteBandPort.execute(bandId)
        logger.info("Finished deleting the band by id {}", bandId)
    }
}