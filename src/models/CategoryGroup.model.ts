import { Model, Column, Table, PrimaryKey, CreatedAt, UpdatedAt, AutoIncrement, BelongsTo, BelongsToMany, HasMany } from "sequelize-typescript";
import Category from "./Category.model"

@Table({ updatedAt: false })
export default class CategoryGroup extends Model<CategoryGroup> {
    @AutoIncrement
    @PrimaryKey
    @Column
    id: number;

    @Column
    name: string;

    @HasMany(() => Category)
    categories: Category[];

    @CreatedAt
    createdAt: Date;
}