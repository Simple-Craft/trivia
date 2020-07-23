import { Model, Column, Table, PrimaryKey, CreatedAt, UpdatedAt } from "sequelize-typescript";

@Table
export default class User extends Model<User> {
    @PrimaryKey
    @Column
    discordId!: string;

    @Column
    username: string;

    @Column
    admin: boolean;

    @CreatedAt
    firstLogin: Date;

    @UpdatedAt
    lastLogin: Date;
}