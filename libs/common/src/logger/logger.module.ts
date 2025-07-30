import { Module } from '@nestjs/common';
import { LoggerModule as PinoLoggerModule } from 'nestjs-pino';

@Module({
  imports: [
    PinoLoggerModule.forRoot({
      pinoHttp: {
        // level: process.env.NODE_ENV === 'production' ? 'info' : 'warn', // limit to warnings in dev
        serializers: {
          req(req) {
            // Return minimal request info
            return {
              method: req.method,
              url: req.url,
            };
          },
        },
        transport:
          process.env.NODE_ENV !== 'production'
            ? {
                target: 'pino-pretty',
                options: {
                  colorize: true,
                  singleLine: true,
                  ignore: 'pid,hostname,req,responseTime',
                },
              }
            : undefined,
      },
    }),
  ],
})
export class LoggerModule {}
