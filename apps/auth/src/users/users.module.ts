import { Module } from '@nestjs/common';
import { UsersController } from './users.controller';
import { UsersService } from './users.service';
import { DatabaseModule, LoggerModule, User } from 'app/common';
import { ClientsModule, Transport } from '@nestjs/microservices';
import { AUTH_SERVICE } from 'app/common/constants';
import { ConfigService } from '@nestjs/config';

@Module({
  imports: [DatabaseModule.forRoot(), DatabaseModule.forFeature([User]), LoggerModule,ClientsModule.registerAsync([
        {
          name: AUTH_SERVICE,
          useFactory: async (configService: ConfigService) => ({
            transport: Transport.TCP,
            options: {
              host: configService.get('AUTH_HOST'),
              port: configService.get('AUTH_PORT'),
            },
          }),
          inject: [ConfigService],
        },
      ]), ],
  controllers: [UsersController],
  providers: [UsersService],
  exports: [UsersService],
})
export class UsersModule {}
