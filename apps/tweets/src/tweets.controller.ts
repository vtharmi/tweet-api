import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  ParseIntPipe,
  Patch,
  Post,
  Query,
  UseGuards,
} from '@nestjs/common';
import { Payload } from '@nestjs/microservices';
import { TweetsService } from './tweets.service';
import { CreateTweetDto } from './dto/create-tweet.dto';
import { UpdateTweetDto } from './dto/update-tweet.dto';
import { CurrentUser, JwtAuthGuard, UserDto } from 'app/common';

@Controller('tweets')
export class TweetsController {
  constructor(private readonly tweetsService: TweetsService) {}

  @Post()
  @UseGuards(JwtAuthGuard)
  create(@Payload() createTweetDto: CreateTweetDto,   @CurrentUser() user: UserDto,) {
    return this.tweetsService.create({ ...createTweetDto, authorId: 3 });
  }

  @Get()
  @UseGuards(JwtAuthGuard)
  async findAll(
    @CurrentUser() user: UserDto,
    @Query('page') page = 1,
    @Query('limit') limit = 10,
  ) {
    return this.tweetsService.findTweetsByUser(
      user.id,
      Number(page),
      Number(limit),
    );
  }

  @Get(':id')
  async findOne(@Param('id', ParseIntPipe) id: number) {
    return this.tweetsService.findOne(id);
  }

  @Patch(':id')
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updateTweetDto: UpdateTweetDto,
    @CurrentUser() user: UserDto,
  ) {
    const userId = user.id;
    return this.tweetsService.update(id, updateTweetDto, userId);
  }

  @Delete(':id')
  async remove(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() user: UserDto,
  ) {
    const userId = user.id;
    return this.tweetsService.remove(id, userId);
  }
}
