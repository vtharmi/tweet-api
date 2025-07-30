import {
  IsEmail,
  IsNotEmpty,
  IsStrongPassword,
} from 'class-validator';

export class CreateUserDto {
  @IsEmail()
  @IsNotEmpty()
  email: string;

  @IsNotEmpty()
 @IsStrongPassword({
    minLength: 8,
  })
  password: string;
}
