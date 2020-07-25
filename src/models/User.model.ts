import { Model, Column, Table, PrimaryKey, CreatedAt, UpdatedAt, Default, HasMany, Unique, AutoIncrement } from "sequelize-typescript";
import Question from "./Question.model"

@Table
export default class User extends Model<User> {
    @AutoIncrement
    @PrimaryKey
    @Column
    id: string;

    @Unique
    @Column
    discordId!: string;

    @Column
    username: string;

    @Default(false)
    @Column
    admin: boolean;

    @HasMany(() => Question)
    questions: Question[];

    @CreatedAt
    firstLogin: Date;

    @UpdatedAt
    lastLogin: Date;
}