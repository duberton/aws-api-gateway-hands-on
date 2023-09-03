package com.duberton.api.gw.adapter.input.api.config

import com.duberton.api.gw.application.port.output.BandRepositoryPort
import com.duberton.api.gw.application.usecase.DeleteBandUseCase
import com.duberton.api.gw.application.usecase.FindBandByIdUseCase
import com.duberton.api.gw.application.usecase.FindBandsUseCase
import com.duberton.api.gw.application.usecase.SaveBandUseCase
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration

@Configuration
class ApiConfig {

    @Bean
    fun saveBandUseCase(bandRepositoryPort: BandRepositoryPort) = SaveBandUseCase(bandRepositoryPort)

    @Bean
    fun findBandByIdUseCase(bandRepositoryPort: BandRepositoryPort) = FindBandByIdUseCase(bandRepositoryPort)

    @Bean
    fun findBandsUseCase(bandRepositoryPort: BandRepositoryPort) = FindBandsUseCase(bandRepositoryPort)

    @Bean
    fun deleteBandUseCase(bandRepositoryPort: BandRepositoryPort) = DeleteBandUseCase(bandRepositoryPort)
}