import { AbstractEntity } from '../database';
import { Column, Entity } from 'typeorm';

@Entity()
export class User extends AbstractEntity<User> {
  
  @Column({type: 'varchar', nullable: false, unique: true})
  
  email: string;

  @Column({type: 'varchar', nullable: false})
  password: string
}
