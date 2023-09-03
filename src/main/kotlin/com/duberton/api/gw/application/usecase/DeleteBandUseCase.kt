package com.duberton.api.gw.application.usecase

import com.duberton.api.gw.application.port.output.BandRepositoryPort
import com.duberton.api.gw.application.port.output.DeleteBandPort

class DeleteBandUseCase(private val bandRepositoryPort: BandRepositoryPort) : DeleteBandPort {

    override fun execute(id: String) = bandRepositoryPort.delete(id)
}