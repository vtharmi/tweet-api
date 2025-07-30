import {
  Injectable,
  NotFoundException,
  UnauthorizedException,
  UnprocessableEntityException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { User } from 'app/common';
import { Repository } from 'typeorm';
import * as bcrypt from 'bcryptjs';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User) private readonly usersRepository: Repository<User>,
  ) {}

  /**
   * Create a new user after validating uniqueness and hashing the password
   */
  async create(createUserDto: CreateUserDto): Promise<User> {
    await this.validateEmailIsUnique(createUserDto);

    const hashedPassword = await bcrypt.hash(createUserDto.password, 10);
    const newUser = this.usersRepository.create({
      ...createUserDto,
      password: hashedPassword,
    });

    return this.usersRepository.save(newUser);
  }

  /**
   * * Get a single user by ID
   * @param id
   * @returns
   */
  async findOne(id: number): Promise<User | null> {
    return this.usersRepository.findOneBy({ id });
  }

  /**
   * Update user details
   * @param id
   * @param updateUserDto
   * @returns
   */
  async updateUser(
    id: number,
    updateUserDto: UpdateUserDto,
  ): Promise<User | null> {
    const user = await this.findOne(id);

    if (!user) {
      throw new NotFoundException(`User with ID ${id} not found.`);
    }

    await this.usersRepository.update(id, updateUserDto);
    return this.usersRepository.findOneBy({ id });
  }

  /**
   * Remove user by ID
   * @param id
   * @returns
   */
  remove(id: number) {
    return this.usersRepository.delete(id);
  }

  /**
   * Ensure the email doesn't already exist in the database
   * @param createUserDto
   */
  private async validateEmailIsUnique(createUserDto: CreateUserDto) {
    const existingUser = await this.usersRepository.findOne({
      where: { email: createUserDto.email },
    });

    if (existingUser) {
      throw new UnprocessableEntityException('Email already exists.');
    }
  }

  /**
   *  Validate if provided credentials match an existing user
   * @param email
   * @param password
   * @returns
   */
  async verifyUser(email: string, password: string): Promise<User> {
    const user = await this.usersRepository.findOne({
      where: { email: email },
    });

    if (!user) {
      throw new UnauthorizedException('User not found.');
    }

    const passwordIsValid = await bcrypt.compare(password, user.password);
    if (!passwordIsValid) {
      throw new UnauthorizedException('Invalid credentials.');
    }
    return user;
  }
}
