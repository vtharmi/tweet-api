import { Module } from '@nestjs/common';
import { TweetsService } from './tweets.service';
import { TweetsController } from './tweets.controller';
import { DatabaseModule, LoggerModule } from 'app/common';
import { Tweet } from './models/tweet.entity';
import * as Joi from 'joi';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { ClientsModule, Transport } from '@nestjs/microservices';
import { AUTH_SERVICE } from 'app/common/constants';

@Module({
  imports: [
    DatabaseModule.forRoot(),
    DatabaseModule.forFeature([Tweet]),
    LoggerModule,
    ConfigModule.forRoot({
      validationSchema: Joi.object({
        PORT: Joi.number().required(),
      }),
    }),
    ClientsModule.registerAsync([
      {
        name: AUTH_SERVICE,
        useFactory: async (configService: ConfigService) => {
          return ({
          transport: Transport.TCP,
          options: {
            host: configService.get('AUTH_HOST'),
            port: configService.get('AUTH_PORT'),
          },
        })
        },
        inject: [ConfigService],
      },
    ]),
  ],
  controllers: [TweetsController],
  providers: [TweetsService],
  exports: [TweetsService],
})
export class TweetsModule {}
