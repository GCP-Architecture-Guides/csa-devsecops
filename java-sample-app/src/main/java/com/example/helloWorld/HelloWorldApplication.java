package com.example.helloWorld;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class HelloWorldApplication {

    @GetMapping("/")
    String home() {
        return "Hello World CSA AppDevSec!";
    }

	public static void main(String[] args) {
		SpringApplication.run(HelloWorldApplication.class, args);
	}

}
