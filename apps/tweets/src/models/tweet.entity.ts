import { AbstractEntity } from 'app/common/database/abstract.entity';
import { Column, CreateDateColumn, Entity, UpdateDateColumn } from 'typeorm';

@Entity()
export class Tweet extends AbstractEntity<Tweet>{

@Column({nullable: false})
content: string;

@Column({nullable: false})
authorId: number;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;


}

