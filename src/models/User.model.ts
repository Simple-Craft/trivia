import { Model, Column, Table, PrimaryKey, CreatedAt, UpdatedAt, Default } from "sequelize-typescript";

@Table
export default class User extends Model<User> {
    @PrimaryKey
    @Column
    discordId!: string;

    @Column
    username: string;

    @Default(false)
    @Column
    admin: boolean;

    @CreatedAt
    firstLogin: Date;

    @UpdatedAt
    lastLogin: Date;
}