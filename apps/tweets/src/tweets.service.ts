import {
  ForbiddenException,
  Injectable,
  Logger,
  NotFoundException,
} from '@nestjs/common';
import { CreateTweetDto } from './dto/create-tweet.dto';
import { UpdateTweetDto } from './dto/update-tweet.dto';
import { Tweet } from './models/tweet.entity';
import { Repository } from 'typeorm';
import { InjectRepository } from '@nestjs/typeorm';

@Injectable()
export class TweetsService {
  protected readonly logger = new Logger(TweetsService.name);
  constructor(
    @InjectRepository(Tweet)
    private readonly tweetsRepository: Repository<Tweet>,
  ) {}

  async create(createTweetDto:  { content: string; authorId: number }): Promise<Tweet> {
    const tweet = this.tweetsRepository.create(createTweetDto);
    return await this.tweetsRepository.save(tweet);
  }

  async findTweetsByUser(userId: number, page = 1, limit = 10) {
    const [tweets, total] = await this.tweetsRepository.findAndCount({
      where: { authorId: userId },
      relations: ['createdBy'],
      order: { createdAt: 'DESC' },
      skip: (page - 1) * limit,
      take: limit,
    });

    return {
      data: tweets,
      meta: {
        total,
        page,
        limit,
        totalPages: Math.ceil(total / limit),
      },
    };
  }

  async findOne(id: number): Promise<Tweet> {
    const tweet = await this.tweetsRepository.findOneBy({ id });
    if (!tweet) {
      this.logger.warn(`Tweet with ID ${id} not found`);
      throw new NotFoundException(`Tweet with ID ${id} not found`);
    }
    return tweet;
  }

  async update(
    id: number,
    updateTweetDto: UpdateTweetDto,
    userId: number,
  ): Promise<Tweet> {
    const tweet = await this.findOne(id);

    this.verifyOwnership(tweet, userId);

    const updated = this.tweetsRepository.merge(tweet, updateTweetDto);
    return this.tweetsRepository.save(updated);
  }

  async remove(id: number, userId: number): Promise<void> {
    const tweet = await this.findOne(id);

    this.verifyOwnership(tweet, userId);

    await this.tweetsRepository.delete(id);
    this.logger.log(`Deleted tweet with ID ${id}`);
  }

  private verifyOwnership(tweet: Tweet, userId: number): void {
    if (tweet.authorId !== userId) {
      this.logger.warn(
        `User ${userId} not authorized to access tweet ${tweet.id}`,
      );
      throw new ForbiddenException('You do not own this tweet');
    }
  }
}
