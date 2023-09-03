package com.duberton.api.gw.application.usecase

import com.duberton.api.gw.application.domain.Band
import com.duberton.api.gw.application.port.output.BandRepositoryPort
import com.duberton.api.gw.application.port.output.FindBandByIdPort
import com.duberton.api.gw.application.port.output.SaveBandPort

class FindBandByIdUseCase(private val bandRepositoryPort: BandRepositoryPort) : FindBandByIdPort {

    override fun execute(id: String) = bandRepositoryPort.findById(id)

}