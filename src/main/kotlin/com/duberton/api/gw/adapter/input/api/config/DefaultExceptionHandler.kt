package com.duberton.api.gw.adapter.input.api.config

import com.duberton.api.gw.adapter.input.api.controller.exception.NotFoundException
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.ControllerAdvice
import org.springframework.web.bind.annotation.ExceptionHandler
import org.springframework.web.context.request.WebRequest
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler

@ControllerAdvice
class DefaultExceptionHandler : ResponseEntityExceptionHandler() {

    @ExceptionHandler(NotFoundException::class)
    fun handleNotFound(ex: NotFoundException, request: WebRequest) =
        ResponseEntity(CustomResponse(404, "RESOURCE_NOT_FOUND"), HttpStatus.NOT_FOUND)
}

class CustomResponse(val status: Int, val code: String)